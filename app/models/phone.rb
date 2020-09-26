class Phone < Contact
  self.regex = '^\+\d{2}\(\d{3}\)\d{3}-\d{2}-\d{2}$'
  self.message = '+X(XXX)XXX-XX-XX'
end
