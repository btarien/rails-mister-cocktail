require 'open-uri'
require 'json'

puts 'clearing db...'
Cocktail.destroy_all
Ingredient.destroy_all

puts 'adding ingredients...'
ingredients = JSON.parse(open('https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list').read)['drinks']
ingredients.each do |ingredient|
  Ingredient.create!(name: ingredient['strIngredient1'])
end
puts Ingredient.all

puts 'adding cocktails...'
10.times do
  data = JSON.parse(open('https://www.thecocktaildb.com/api/json/v1/1/random.php').read)['drinks'][0]
  cocktail = Cocktail.new(
    name: data['strDrink']
  )
  image = URI.open(data['strDrinkThumb'])
  cocktail.image.attach(
    io: image,
    filename: "#{data['strDrink']}.jpeg",
    content_type: 'application/jpeg'
  )
  cocktail.save!
end

puts Cocktail.all
