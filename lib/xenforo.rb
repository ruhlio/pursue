require 'sequel'

class XenForo

   DB = Sequel.connect('mysql://root:sql@localhost/pursue_community')

   def self.get_threads( forum_node_id, thread_count )
      DB.fetch(%Q{
         select thread.title as title,
                post.post_date as date,
                post.message as message
         from xf_post post
         join xf_thread thread on thread.first_post_id = post.post_id
         where thread.node_id = :node_id
         limit :thread_count
      },
         :node_id => forum_node_id,
         :thread_count => thread_count
      ).all
   end

   def self.create_thread( forum_node_id, username, title, message )
      post_date = Time.now
      user_id = get_user_id( username )

      DB.transaction do
         thread_id = DB[:xf_thread].insert(
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

         post_id = DB[:xf_post].insert(
            :thread_id => thread_id,
            :user_id => user_id,
            :username => username,
            :post_date => post_date,
            :message => message,
            :position => 0,
            :like_users => ''
         )

         rows_updated = DB[:xf_thread].update(
            :first_post_id => post_id,
            :last_post_id => post_id
         ).
         where(
            :thread_id => thread_id
         )

         if 1 != rows_updated
            raise Sequel::Rollback
            #TODO: log error
         end

      end

   end

   def get_user_id( username )
      DB[:xf_user].select(
         :user_id
      ).where(
         :username => username
      ).first
   end

end
