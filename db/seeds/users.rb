require "faker"
if User.count.zero?
  puts "Seeding users..."
  puts "Admin ..."
  person =  Person.where(name: "Serge", surname: "Pauli", middlename:"Al.").take()
  if person === nil
    person = Person.new(name: "Serge", surname: "Pauli", middlename:"Al.")
  end
  arg = Proc.new {true}
  if person.contacts.find(arg) {|c| c.data == "sergepauli@yandex.ru"}
    email = Email.new(data: "sergepauli@yandex.ru", description: 'can be used for authenication')
    person.contacts.push(email)
  end
  user = User.create(email: "sergepauli@yandex.ru", login: "Admin", password: "admin123", 
    job: "System's admin", member: "admins", person: person)
  user.save 
  puts "Directorate ..."
  2.times { |i|
    person_str = Faker::Name.unique.name
    surname =  person_str.split(" ").last
    name = person_str.split(" ").first
    person =  Person.where(name: name, surname: surname).take()
    if person === nil
      person = Person.new(name: name, surname: surname)
    end
    email_str = Faker::Internet.email(name: name)
    email = Email.new(data: email_str, description: 'can be used for authenication')
    person.contacts.push(email)
    job = Faker::Job.position
    user = User.create(email: email_str, login: "dir#{i}", password: "dir#{i}dir#{i}", job: job, 
      member: "Dir", person: person)
    if user.save
    else
      puts user.errors.to_json
    end  
  }
  puts "Commers ..."
  3.times { |i|
    person_str = Faker::Name.unique.name
    surname =  person_str.split(" ").last
    name = person_str.split(" ").first
    person =  Person.where(name: name, surname: surname).take()
    if person === nil
      person = Person.new(name: name, surname: surname)
    end
    email_str = Faker::Internet.email(name: name)
    email = Email.new(data: email_str, description: 'can be used for authenication')
    person.contacts.push(email)
    user = User.create(email: email_str, login: "comm#{i}", password: "comm#{i}comm#{i}", job: Faker::Job.position, 
    member: "comm", person: person)
    if user.save
    else
      puts user.errors.to_json
    end 
  } 
  puts "Technicians ..."
  3.times { |i|
    person_str = Faker::Name.unique.name
    surname =  person_str.split(" ").last
    name = person_str.split(" ").first
    person =  Person.where(name: name, surname: surname).take()
    if person === nil
      person = Person.new(name: name, surname: surname)
    end
    email_str = Faker::Internet.email(name: name)
    email = Email.new(data: email_str, description: 'can be used for authenication')
    person.contacts.push(email)
    user = User.create(email: email_str, login: "tech#{i}", password: "tech#{i}tech#{i}", job: "Technician #{Faker::Job.seniority}", 
    member: "tech", person: person)
    if user.save
    else
      puts user.errors.to_json
    end 
  }
  puts "Accountants ..."
  3.times { |i|
    person_str = Faker::Name.unique.name
    surname =  person_str.split(" ").last
    name = person_str.split(" ").first
    person =  Person.where(name: name, surname: surname).take()
    if person === nil
      person = Person.new(name: name, surname: surname)
    end
    email_str = Faker::Internet.email(name: name)
    email = Email.new(data: email_str, description: 'can be used for authenication')
    person.contacts.push(email)
    user = User.create(email: email_str, login: "book#{i}", password: "book#{i}book#{i}", job: "Accountant #{Faker::Job.seniority}", 
    member: "book", person: person)
    if user.save
    else
      puts user.errors.to_json
    end 
  }
end