class Email < Contact
  self.regex = '^([a-z0-9_-]+\.)*[a-z0-9_-]+@[a-z0-9_-]+(\.[a-z0-9_-]+)*\.[a-z]{2,6}$'
  self.message = 'email like ____@___.__'
end
