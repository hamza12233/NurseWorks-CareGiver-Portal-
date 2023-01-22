class AddRecoverIntoUserDoc < ActiveRecord::Migration[6.1]
  def change
    add_column :user_docs, :recover, :boolean, default: false
  end
end
