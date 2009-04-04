class DealController < ApplicationController
  
  before_filter :login_required, :only => ['edit', 'create']
  
  def index
    redirect_to :action => "list"
  end

  def show
    @deal = Deal.find(params[:id])
    @title = @deal.title
    if request.post?
      @comment = current_user.comments.build(params[:comment])
      @comment.deal_id = @deal.id
      if @comment.save
        flash[:notice] = "Successfully commented..."
        redirect_to :action => "show", :id => params[:id]
      else
        render :action => 'show'
      end
    end
  end

  def list
    @deal = Deal.paginate :page => params[:page], :order => 'updated_at DESC'
    @title = 'List'
  end

  def create
    @deal = Deal.new
    @title = 'Create'
    if request.post?
      @deal = current_user.deals.build(params[:deal])
      @deal.tag_list = params[:tag]
      if @deal.save
        @dda = Dda.create(:deal => @deal)
        # @dda.generate
        MiddleMan.worker(:ddaw_worker).enq_execdda(:arg => @dda, :job_key => @dda.id.to_s)
        flash[:notice] = "Successfully created..."
        redirect_to :action => "show", :id => @deal.id
      else
        render :action => 'create'
      end
    end
  end

  def edit
    @deal = current_user.deals.find(params[:id])
    @title = "Edit::#{@deal.title}"
    @tag = @deal.tag_list
    if request.post?
      @deal.update_attributes(params[:deal])
      @deal.tag_list = params[:tag]
      @deal.save!
      flash[:notice] = "Successfully edited..."
      redirect_to :action => "show", :id => @deal.id
    end
  end

  def delete
    @deal = current_user.deals.find(params[:id])
    @deal.destroy
    flash[:notice] = "Successfully deleted..."
    redirect_to :action => "list"
  end
  
  def user
    @deal = User.find_by_login(params[:id]).deals.paginate :page => params[:page], :order => 'updated_at DESC'
    @word = "Deals by #{params[:id]}"
    @title = "User::#{params[:id]}"
    render :action => 'list'
  end
  
  def tag
    @deal = Deal.find_tagged_with(params[:id], :on => :tags).paginate :page => params[:page], :order => 'updated_at DESC'
    @word = "Deals tagged with #{params[:id]}"
    @title = "Tag::#{params[:id]}"
    render :action => 'list'
  end
  
  def deletecomment
    @comment = current_user.comments.find(params[:id])
    @deal = @comment.deal
    @comment.destroy
    flash[:notice] = "Successfully deleted..."
    redirect_to :action => "show", :id => @deal.url
  end
end
