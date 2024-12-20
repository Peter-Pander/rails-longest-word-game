# app/controllers/games_controller.rb

require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample } # Generates 10 random letters
  end

  def score
    user_word = params[:word].upcase
    grid = params[:grid].split(',')

    # Scenario 1: Check if the word can be built from the grid
    if can_be_built?(user_word, grid)
      # Scenario 2: Check if it's a valid English word
      if valid_english_word?(user_word)
        @message = "Congratulations #{user_word} is a valid English word!"
        @current_word_score = calculate_score(user_word) # Calculate the score for this word
      else
        @message = "Sorry but - #{user_word} - does not seem to be a valid English word..."
        @current_word_score = 0
      end
    else
      @message = "Sorry but - #{user_word} - can't be built out of #{grid.join(', ')}"
      @current_word_score = 0
    end

    render 'score'
  end

  private

  def can_be_built?(word, grid)
    word_chars = word.chars
    word_chars.all? { |char| word_chars.count(char) <= grid.count(char) }
  end

  def valid_english_word?(word)
    url = "https://dictionary.lewagon.com/#{word.downcase}"
    response = URI.open(url).read
    result = JSON.parse(response)

    result && result['found'] == true
  rescue OpenURI::HTTPError, JSON::ParserError => e
    Rails.logger.error "Error fetching word: #{e.message}"
    false
  end

  def calculate_score(word)
    word.length ** 2 # Square of the word length as the score
  end
end
