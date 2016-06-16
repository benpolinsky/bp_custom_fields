require 'rails_helper'


RSpec.describe BpCustomFields::Appearance, type: :model do
  before do
    @appearance = BpCustomFields::Appearance.new
  end

    
  it "belongs_to a group_template" do
    expect(@appearance.create_group_template(name: "Badge")).to be_a BpCustomFields::GroupTemplate
  end
  
  context "returning conditions" do
    context "resource based" do
      before do
        class ::Post < ActiveRecord::Base
          include BpCustomFields::Fieldable
        end
      end
      
      it "one appearance can return all of a resource as a collection" do 
        three_posts = Post.where(nil)
        3.times { |i| three_posts << Post.create(title: "A Post ##{i}")}
        appearance = BpCustomFields::Appearance.create(resource: "Post")
        expect(appearance.appears_on).to eq three_posts
      end
      
      it "a collection of appearances can return all of a resouce" do
        three_posts = Post.where(nil)
        3.times { |i| three_posts << Post.create(title: "A Post ##{i}")}
        appearance = BpCustomFields::Appearance.create(resource: "Post")
        expect(BpCustomFields::Appearance.all.appears_on).to match three_posts
      end
      
      it "one appearance can return a single instance of a resource as a record" do
        only_post = Post.create(title: "only post")
        appearance = BpCustomFields::Appearance.create(resource: "Post")
        expect(appearance.appears_on).to eq only_post
      end
      
      it "a collection of appearances can return a single instance of a resource as a record" do
        only_post = Post.create(title: "only post")
        appearance = BpCustomFields::Appearance.create(resource: "Post")
        second_appearance = BpCustomFields::Appearance.create(resource: "Post")
        expect(BpCustomFields::Appearance.all.appears_on).to eq only_post
      end
    
      it "a collection of appearances can return all of a resource minus one record" do
        three_posts = Post.where(nil)
        3.times { |i| three_posts << Post.create(title: "A Post ##{i}")}
        exception_post = three_posts.first
        BpCustomFields::Appearance.create(resource: "Post")
        BpCustomFields::Appearance.create(resource: "Post", resource_id: exception_post.id, appears: false)
        expect(BpCustomFields::Appearance.all.appears_on).to match three_posts.where.not(id: exception_post.id)
      end
    
      it "can return all of a resource minus three records" do
        ten_posts = Post.where(nil)
        three_posts = Post.where(nil)
        3.times {|i| three_posts << Post.create(title: "Nope #{i}")}
        10.times {|i| ten_posts << Post.create(title: "Yup #{i}")}
        
        BpCustomFields::Appearance.create(resource: "Post")
        three_posts.each do |post|
          BpCustomFields::Appearance.create(resource: "Post", resource_id: post.id, appears: false)
        end
        
        expect(BpCustomFields::Appearance.all.appears_on).to match ten_posts.where.not(id: three_posts.map(&:id))
      end
      
      it "can return a mixture of two different resources" do

        
        class ::Person < ActiveRecord::Base
          include BpCustomFields::Fieldable
        end      

        Person.delete_all
        three_people = Person.where(nil)
        five_posts = Post.where(nil)
        
        
        # this seems to be neccessary b/c of the dynamic creation of the table/model?
        # really not sure... I've used the where(nil) other places without these results
        
        three_people.reload 
        five_posts.reload
        
        3.times {|i| three_people << Person.create(first_name: "Person #{i}")}
        5.times {|i| five_posts << Post.create(title: "Post #{i}")}

        BpCustomFields::Appearance.create(resource: "Person")
        BpCustomFields::Appearance.create(resource: "Post")
        expect(BpCustomFields::Appearance.all.appears_on).to match [three_people, five_posts].flatten

        Person.delete_all
        Post.delete_all
                
      end

      it "can return a mixture of two different resources, with only one resource subtracting from its collection", focus: true do

        
        class ::Person < ActiveRecord::Base
          include BpCustomFields::Fieldable
        end      

        Person.delete_all
        three_people = Person.where(nil)
        five_posts = Post.where(nil)
        
        
        # this seems to be neccessary b/c of the dynamic creation of the table/model?
        # really not sure... I've used the where(nil) other places without these results
        
        three_people.reload 
        five_posts.reload
        
        3.times {|i| three_people << Person.create(first_name: "Person #{i}")}
        5.times {|i| five_posts << Post.create(title: "Post #{i}")}
        four_posts = five_posts.where.not(id: five_posts.last.id)

        BpCustomFields::Appearance.create(resource: "Post")        
        BpCustomFields::Appearance.create(resource: "Post", resource_id: five_posts.last.id, appears: false)
        BpCustomFields::Appearance.create(resource: "Person")
        expect(BpCustomFields::Appearance.all.appears_on).to match [four_posts, three_people].flatten

        Person.delete_all
        Post.delete_all
        
        
      end

      it "can return a mixture of two different resources, each subtracting a respective record" do

        
        class ::Person < ActiveRecord::Base
          include BpCustomFields::Fieldable
        end      

        Person.delete_all
        three_people = Person.where(nil)
        five_posts = Post.where(nil)
        
        
        # this seems to be neccessary b/c of the dynamic creation of the table/model?
        # really not sure... I've used the where(nil) other places without these results
        
        three_people.reload 
        five_posts.reload
        
        3.times {|i| three_people << Person.create(first_name: "Person #{i}")}
        5.times {|i| five_posts << Post.create(title: "Post #{i}")}
        four_posts = five_posts.where.not(id: five_posts.last.id)
        two_people = three_people.where.not(id: three_people.last.id)

        BpCustomFields::Appearance.create(resource: "Post")        
        BpCustomFields::Appearance.create(resource: "Post", resource_id: five_posts.last.id, appears: false)
        BpCustomFields::Appearance.create(resource: "Person")
        BpCustomFields::Appearance.create(resource: "Person", resource_id: three_people.last.id, appears: false)
        
        expect(BpCustomFields::Appearance.all.appears_on).to match [four_posts, two_people].flatten

        Person.delete_all
        Post.delete_all
      end
    
      it "can return a mixture of two different resources, each subtracting several records" do

        
        class ::Person < ActiveRecord::Base
          include BpCustomFields::Fieldable
        end      

        Person.delete_all
        five_people = Person.where(nil)
        five_posts = Post.where(nil)
        
        
        # this seems to be neccessary b/c of the dynamic creation of the table/model?
        # really not sure... I've used the where(nil) other places without these results
        
        five_people.reload 
        five_posts.reload
        
        5.times {|i| five_people << Person.create(first_name: "Person #{i}")}
        5.times {|i| five_posts << Post.create(title: "Post #{i}")}
        one_post = five_posts.first
        one_person = five_people.first

        BpCustomFields::Appearance.create(resource: "Post")        
        BpCustomFields::Appearance.create(resource: "Post", resource_id: five_posts[1].id, appears: false)
        BpCustomFields::Appearance.create(resource: "Post", resource_id: five_posts[2].id, appears: false)
        BpCustomFields::Appearance.create(resource: "Post", resource_id: five_posts[3].id, appears: false)
        BpCustomFields::Appearance.create(resource: "Post", resource_id: five_posts[4].id, appears: false)

        BpCustomFields::Appearance.create(resource: "Person")
        BpCustomFields::Appearance.create(resource: "Person", resource_id: five_people[1].id, appears: false)
        BpCustomFields::Appearance.create(resource: "Person", resource_id: five_people[2].id, appears: false)
        BpCustomFields::Appearance.create(resource: "Person", resource_id: five_people[3].id, appears: false)
        BpCustomFields::Appearance.create(resource: "Person", resource_id: five_people[4].id, appears: false)
        
        expect(BpCustomFields::Appearance.all.appears_on).to match [one_post, one_person]

        Person.delete_all
        Post.delete_all
      end
      
      # pending "can return all of a resource minus all but one record"
      
      # pending "can return all of a resouce minus n using a range of ids rather than several appearances"
      
      # pending "can return scopes of a resource - possible?"
      
      # pending "has a #readable method to describe each query in english" do
      #   appearance = BpCustomFields::Appearance.create(resource: "Post")
      #   expect(appearance.readable).to eq "All Posts"
      # end
    end
    
    
    
    
    context "abstract based" do
      
      it "one appearance can return all of a resource as a collection" do 
        appearance = BpCustomFields::Appearance.create(resource: "AbstractAppearance")
        # expect(appearance.appears_on).to eq three_posts
      end
    end
    
    # other ideas for appearances
  end
end