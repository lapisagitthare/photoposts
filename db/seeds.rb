(1..100).each do |number|
  Photopost.create(title: 'test title ' + number.to_s, image: 'test content ' + number.to_s, user_id:6)
end