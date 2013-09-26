class CreateRequestHistories < ActiveRecord::Migration
  def change
    create_table :request_histories do |t|
      t.string :uid # not 'id' as it is not int
      t.string :device_id
      t.string :name
      t.string :status
      t.string :job_service_id
      t.integer :session_id
      t.string :arguments 
      t.string :description
      t.datetime :created_at
      t.datetime :activated_at
      t.datetime :started_at
      t.datetime :ended_at
      t.datetime :expired_at
      t.string :notification_type
      t.string :notification_uri
      t.timestamps
    end
  end
end
