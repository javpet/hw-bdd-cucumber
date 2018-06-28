Feature: User can add movie by searching for it in the Movie Database (TMDB)

Scenario: Try to add a nonexistent movie (sad path)
  Given I am on the RottenPotatoes home page
  Then I should see "Search TMDB for a movie"
  When I fill in "Search Terms" with "Movie That Does Not Exist"
  And I press "Search TMDB"
  Then I should be on the RottenPotatoes home page
  And I should see "'Movie That Does Not Exist' was not found in TMDB"
