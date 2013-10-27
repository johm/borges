# -*- coding: utf-8 -*-
class Image < ActiveRecord::Base
  attr_accessible :the_image, :title, :remote_the_image_url,:description,:link
  belongs_to :imagey, :polymorphic => true
  mount_uploader :the_image, ImageUploader
end
