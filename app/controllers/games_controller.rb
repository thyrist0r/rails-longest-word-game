require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    grid_size = 15
    counter = 0
    a = []
    charset = [*"A".."Z"]
    while counter < grid_size
      a << charset.sample(1)
      counter += 1
    end
    @letters_a = a
    @letters = a.flatten
  end

  def score
    letter_array = creating_letter_array(params[:user_enter])
    word_check = url_word_check(params[:user_enter])
    a = params[:user_enter].gsub(" ","").split("")
    grid_hash = creating_grid_hash(a)
    if word_part_of_grid(grid_hash, letter_array)
      @gridcheck = "Word is part of the grid "
    else
      @gridcheck = "Word is NOOOOOOT part of the grid "
    end
    if word_check["found"] == true
      @word_english = "Word is a english word"
    else
      @word_english = "Word is NOOOOOT a english word"
    end
  end

private
  def creating_letter_array(attempt)
    return attempt.split("").map { |a| a.upcase }
  end

  def url_word_check(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    return JSON.parse(user_serialized)
  end

  def creating_grid_hash(grid)
    grid_hash = Hash.new(0)
    grid.flatten.each do |letter|
      grid_hash[letter] += 1
    end
    return grid_hash
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end



  def word_part_of_grid(grid_hash, letter_array)
    letter_array.each do |letter|
      if grid_hash[letter] != 0
        grid_hash[letter] -= 1
      else
        return false
      end
    end
    return true
  end
end
