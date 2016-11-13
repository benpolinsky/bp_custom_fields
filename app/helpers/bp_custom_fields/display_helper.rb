# methods to help display field values in views

module BpCustomFields
  module DisplayHelper

    def display_field(field)
      case field.field_type
      when 'gallery'
        field.to_a
      when 'image'
        display_image_field(field)
      when 'video'
        display_video_field(field)
      else
        field.value
      end
    end
    

    private 
    
    def display_image_field(field)
      image_tag field.file.url, class: "bpcf-image-#{field.label}", alt: field.label
    end

    def display_video_field(field)
      video = BpCustomFields::Video.new(field.address)
      video_embed_html(video)
    end
    
    def video_embed_html(video)
      content_tag :div, class: "bpcf-embed-container" do
        content_tag :iframe, nil, src: video.embed_address, frameborder: 0, allowfullscreen: ''
      end
    end
    
    def deep_find(hash, found=nil)
      key = 'groups_attributes'
      if hash.respond_to?(:key?) && hash.key?(key)
        return hash[key]
      elsif hash.is_a? Enumerable
        hash.find { |*a| found = deep_find(a.last) }
        return found
      end
    end
    
  end
end