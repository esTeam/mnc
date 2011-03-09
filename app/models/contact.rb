# create the contact tableless record

class Contact < Tableless
  column :name,          :string
  column :email_address, :string
  column :subject,       :string
  column :body,          :text
  validates_presence_of  :name, :email_address
  validates_format_of    :email_address,
                         :with => %r{\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z}i, 
                         :message => "כתוב בפורמט שגוי. תקן לפי xxx@yyy.zzz"
end 