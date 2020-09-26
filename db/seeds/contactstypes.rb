if Contactstype.count.zero?
  puts "Seeding types of contact..."
  Contactstype.create(name: 'email', regex: '^([a-z0-9_-]+\.)*[a-z0-9_-]+@[a-z0-9_-]+(\.[a-z0-9_-]+)*\.[a-z]{2,6}$')
  Contactstype.create(name: 'mobile phone', regex:'^\+\d{2}\(\d{3}\)\d{3}-\d{2}-\d{2}$')
  Contactstype.create(name: 'home phone', regex:'^\+\d{2}\(\d{3}\)\d{3}-\d{2}-\d{2}$')
  Contactstype.create(name: 'WhatsApp', regex:'^\+\d{2}\(\d{3}\)\d{3}-\d{2}-\d{2}$')
  Contactstype.create(name: 'Telegram')
  Contactstype.create(name: 'Viber', regex:'^\+\d{2}\(\d{3}\)\d{3}-\d{2}-\d{2}$')
  Contactstype.create(name: 'URL', regex:'^((https?|ftp)\:\/\/)?([a-z0-9]{1})((\.[a-z0-9-])|([a-z0-9-]))*\.([a-z]{2,6})(\/?)$')
end
