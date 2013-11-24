class CreateUsers < ActiveRecord::Migration
  def up
    create_table :groups do |t|
      t.string :name
      t.integer :author_id
      t.timestamps
    end
    create_table :records do |t|
      t.date :start_time
      t.date :end_time
      t.integer :difficulty
      t.integer :problem_id
      t.timestamps
    end

    create_table :problems do |t|
      t.string :name
      t.integer :difficulty
      t.date :end_date
    end
    create_table :users do |t|
      t.string :login
      t.string :name
      t.string :email
      t.string :password
      t.text :info
      t.timestamps
    end
    create_table :group_members, {:id => false, :force => true} do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :is_leader
    end
    create_table :targets, {:id => false, :force => true} do |t|
      t.integer :group_id
      t.integer :problem_id
    end
    create_table :subproblems, {:id => false, :force => true} do |t|
      t.integer :child_id
      t.integer :parent_id
    end

    create_table :calendars do |t|
      t.integer :user_id, null:true
      t.integer :group_id, null:true
    end


    create_table :problem_groups do |t|
      t.string :name
    end

    create_table :workers, {:id => false, :force => true} do |t|
      t.integer :user_id
      t.integer :problem_id
    end

    create_table :friends, {:id => false, :force => true} do |t|
      t.integer :user_id
      t.integer :friend_id
    end

    User.create(login: "Admin", name:"Admin", email: "admin@admin.com", password: "111", info: "Admin info")
    User.create(login: "User", name:"User", email:"user@user.com", password: "111", info: "simple user")
    Calendar.create(user_id: 1)
    Calendar.create(user_id: 2)

  end

  def down
    drop_table :groups
    drop_table :users
    drop_table :group_members
    drop_table :problem_groups
    drop_table :subproblems
    drop_table :problems
    drop_table :targets
    drop_table :records
    drop_table :calendars
    drop_table :workers
  end
end
