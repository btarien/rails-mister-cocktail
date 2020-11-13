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

  puts 'adding doses...'
  15.times do |index|
    ingredient = data["strIngredient#{index + 1}"]
    ingredient = Ingredient.find_by(name: ingredient)
    break if ingredient.nil?

    dose_desc = data["strMeasure#{index + 1}"]
    dose_desc = 'a dash' if dose_desc.nil?
    dose = Dose.new(description: dose_desc)
    dose.ingredient = ingredient
    dose.cocktail = cocktail
    dose.save!
    puts dose
  end
end

puts Cocktail.all
