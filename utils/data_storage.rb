# rubocop: disable Metrics
# frozen_string_literal: true

require 'json'
require_relative '../classes/game'
require_relative '../classes/musicAlbum'
require_relative '../classes/author'

# module DataStorage
module DataStorage
  def save_data(filename, data)
    File.open(filename, 'w') do |file|
      file.puts data.to_json
    end
  end

  def load_data(filename)
    JSON.parse(File.read(filename))
  end

  def save_games
    data = []
    games = App.class_variable_get(:@@games)
    games.each do |game|
      data << ({ multiplayer: game.multiplayer, last_played_at: game.last_played_at,
                 publish_date: game.publish_date })
      save_data('game.json', data)
    end
  end

  def save_albums
    data = []
    albums = App.class_variable_get(:@@albums)
    albums.each do |album|
      data << ({ publish_date: album.publish_date,
                 on_spotify: album.on_spotify, name: album.name, genre: album.genre })
      save_data('album.json', data)
    end
  end

  def save_author
    data = []
    authors = App.class_variable_get(:@@authors)
    authors.each do |author|
      data << ({ first_name: author.first_name, last_name: author.last_name })
      save_data('author.json', data)
    end
  end

  def load_games
    filename = 'game.json'
    games = App.class_variable_get(:@@games)
    if File.exist? filename
      data = load_data(filename)
      data.map do |game|
        new_game = Game.new(game['multiplayer'], game['last_played_at'], game['publish_date'])
        games << new_game
      end
    else
      []
    end
  end

  def load_albums
    filename = 'album.json'
    albums = App.class_variable_get(:@@albums)
    if File.exist? filename
      data = load_data(filename)
      data.map do |album|
        new_album = MusicAlbum.new(album['name'], album['genre'], album['publish_date'], album['on_spotify'])
        albums << new_album
      end
    else
      []
    end
  end

  def load_authors
    filename = 'author.json'
    authors = App.class_variable_get(:@@authors)
    if File.exist? filename
      data = load_data(filename)
      data.map do |author|
        new_author = Author.new(author['first_name'], author['last_name'])
        authors << new_author
      end
    else
      []
    end
  end
end
# rubocop: enable Metrics
