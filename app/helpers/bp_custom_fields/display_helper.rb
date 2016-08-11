# This will become a helper for displaying different types of custom fields
# TODO: move the parameter stuff to a different helper.

module BpCustomFields
  module DisplayHelper
    def bp_display_video(address)
      video = BpCustomFields::Video.new(address)
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