# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

When /I follow “(.*)”/ do |sort_choice|
  if sort_choice == "Movie Title"
    click_link('Movie Title')
  elsif sort_choice == "Release Date"
    click_link('Release Date')
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.

  body = page.body.to_s
  e1_index = body.index(e1) #http://ruby-doc.org/core-2.5.1/String.html#method-i-index
  e2_index = body.index(e2)
  e1_index < e2_index
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(", ")
  ratings.each do |rating|
    if uncheck
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end

Then(/^I should (not )?see movies rated: (.*)/) do |uncheck, rating_list|
  @ratings = rating_list.split(", ")
  within_table("movies") do
    if uncheck
      Movie.where(rating: @ratings).each do |movie|
        expect(page).to_not have_content(movie.title)
      end
    else
      Movie.where(rating: @ratings).each do |movie|
        expect(page).to have_content(movie.title)
      end
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  expect(page).to have_selector("table tbody tr", count: 10) #https://stackoverflow.com/questions/2986250/how-to-assert-on-number-of-html-table-rows-in-ruby-using-capybara-cucumber
end
