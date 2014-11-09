class AddSecretToOption < ActiveRecord::Migration
  def up
    add_column :options, :secret, :string
    Option.all.each do |option|
      option.generate_secret
    end
  end
end
