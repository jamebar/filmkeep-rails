class List < ActiveRecord::Base
  has_many :film_list
  has_many :films, :through => :film_list
  has_many :comments,  as: :commentable
  belongs_to :user
  before_destroy :detach_films

  include StreamRails::Activity
  as_activity

  def self.default_scope
    includes(:films, :user, :comments)
  end

  def title
    name
  end

  def serializable_hash(options={})
    options = { 
      :include => [:user, :films, :comments]
    }.update(options)
    super(options)
  end

  def activity_object
    self
  end

  def detach_films
    films.clear
  end

  def to_h
    serializable_hash.tap do |l|
      l[:films] = film_list.map do |fl|
        fl.film.serializable_hash.tap {|flf| flf[:sort_order] = fl.sort_order} 
      end
    end
  end

  def films_to_h
    film_list.map do |fl|
      fl.film.serializable_hash.tap {|flf| flf[:sort_order] = fl.sort_order} 
    end
  end

  def add(film, sort_order)
    film_list.find_or_create_by(film_id: film.id) do |fl|
      fl.sort_order = sort_order
    end
  end

  def remove(film, sort_order = nil)
    films.delete(film)
    reload
    ids = films.pluck(:id)
    set_sort_order(ids)
  end

  def set_sort_order(ordered_ids)
    ordered_ids.each_with_index do |id, index|
      film_list.find_by_film_id(id).update(sort_order: index)
    end
  end

end