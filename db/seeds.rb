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
  cocktail = JSON.parse(open('https://www.thecocktaildb.com/api/json/v1/1/random.php').read)['drinks'][0]
  Cocktail.create!(
    name: cocktail['strDrink'],
    image_url: cocktail['strDrinkThumb']
  )
end

puts Cocktail.all
