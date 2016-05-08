module BpCustomFields
  module DisplayHelper
    def bp_display_video(address)
      video = BpCustomFields::Video.new(address)
      video_embed_html(video)
    end
    
    
    private 
    
    def video_embed_html(video)
      content_tag :div, class: "bpcf-embed-container" do
        content_tag :iframe, nil, src: video.embed_address, frameborder: 0, allowfullscreen: ''
      end
    end
  end
end