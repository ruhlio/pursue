require 'sequel'
require 'log4r'

class XenForo

   def initialize( connection_string )
      @logger = Log4r::Logger.new( XenForo.name )
      @connection_string = connection_string
   end


   def get_threads( forum_node_id, options = {} )
      sql = %Q{
         select thread.title as title,
                post.post_date * 1000 as date,
                post.message as message
         from xf_post post
         join xf_thread thread on thread.first_post_id = post.post_id
         where thread.node_id = :node_id
         order by post.post_date desc
      }

      args = {
         :node_id => forum_node_id
      }

      if options.has_key? :max
         sql << "\nlimit :max"
         args[:max] = options[:max]
      end

      connection = get_connection
      threads = connection.fetch( sql, args ).all
      if options.has_key? :bbcode
         threads.each do |thread|
            if options[:bbcode] == :strip
               thread[:message].bbcode_to_text!
            elsif options[:bbcode] == :render
               thread[:message].bbcode_to_html!
            end
         end
      end
      connection.disconnect

      threads
   end

   def get_user_profiles( user_groups )
      user_profiles = []

      connection = get_connection
      connection.fetch(%Q{
select str_to_date(concat(user_profile.dob_day, '-', user_profile.dob_month, '-', user_profile.dob_year), '%Y-%m-%d') date_of_birth,
       user_profile.location location,
       user_group.title title,
       user_profile.about about,
       user.user_id id,
       user.username username
from xf_user_profile user_profile
join xf_user user on user.user_id = user_profile.user_id
join xf_user_group user_group on user_group.user_group_id = user.user_group_id
where user_group.title in :user_groups
      }, {
         :user_groups => user_groups
      }).each do |user_profile|
         user_profile[:about].bbcode_to_text!
         user_profiles << user_profile
      end
      connection.disconnect

      user_profiles
   end

   def create_thread( forum_node_id, username, title, message )
      connection = get_connection
      post_date = Time.now
      user_id = get_user_id( connection, username )

      connection.transaction do
         thread_id = connection[:xf_thread].insert(
            :node_id => forum_node_id,
            :title => title,
            :user_id => user_id,
            :username => username,
            :post_date => post_date,
            :first_post_id => 0,
            :last_post_id => 0,
            :last_post_date => post_date,
            :last_post_user_id => user_id,
            :last_post_username => username
            )

         post_id = connection[:xf_post].insert(
            :thread_id => thread_id,
            :user_id => user_id,
            :username => username,
            :post_date => post_date,
            :message => message,
            :position => 0,
            :like_users => ''
         )

         rows_updated = connection[:xf_thread].update(
            :first_post_id => post_id,
            :last_post_id => post_id
         ).
         where(
            :thread_id => thread_id
         )

         if 1 != rows_updated
            raise Sequel::Rollback
            logger.error "Failed to create forum post due to #{rows_updated} rows being updated"
         end

      end

   end

private

   def get_connection
      Sequel.connect( @connection_string )
   end

   def get_user_id( connection, username )
      connection.fetch(%Q{
         select user_id
         from xf_user
         where username = :username
      }, {
         :username => username
      }).first
   end

end
