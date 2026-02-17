# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Initial Market Inventory
prizes = [
  { name: "Blåhaj", description: "The legendary IKEA shark. A Hack Club favorite.", cost: 100, stock_count: 5, category: "Plushies", image_url: "/static-assets/prizes/blahaj.webp" },
  { name: "Hack Club Stickers", description: "A pack of various Hack Club stickers to cover your laptop.", cost: 10, stock_count: 100, category: "Swag", image_url: "/static-assets/prizes/stickers.webp" },
  { name: "Vintage Notebook", description: "A high-quality notebook for sketching your next big idea.", cost: 50, stock_count: 20, category: "Swag", image_url: "/static-assets/prizes/notebook.webp" },
  { name: "Circuit Playground Express", description: "Electronics for the adventurous maker.", cost: 250, stock_count: 3, category: "Hardware", image_url: "/static-assets/prizes/cpx.webp" },
  { name: "Raspberry Pi 5", description: "The latest and greatest in single-board computing.", cost: 800, stock_count: 2, category: "Hardware", image_url: "/static-assets/prizes/rpi5.webp" }
]

prizes.each do |prize_data|
  Prize.find_or_create_by!(name: prize_data[:name]) do |p|
    p.description = prize_data[:description]
    p.cost = prize_data[:cost]
    p.stock_count = prize_data[:stock_count]
    p.category = prize_data[:category]
    p.image_url = prize_data[:image_url]
  end
end
