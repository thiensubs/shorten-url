# frozen_string_literal: true

class Api::V1::MyLinksController < Api::V1::ApiController
  protect_from_forgery unless: -> { request.format.json? }
  before_action :authenticate_user!
  before_action :set_link, only: [:show, :update, :destroy]

  resource_description do
    # resource_id '1'
    short 'This is API support for your shorten link'
    formats ['json']
    description <<-EOF
    EOF
  end
  api :GET, 'api/v1/my_links', 'API listing your links'
  description <<-EOF
      =NOTES:
       THIS REQUIRED AUTHENTICATION VIA JWT TOKEN, MAKE SURE YOU ARE SIGN IN AND ADD JIT TOKEN TO HEADER.
      =EX:
        request["Authorization"] = "Bearer 90a7e4bb-85fc-42c4-959a-3478e7253b34"
  EOF

  # errors code if have any
  error code: 404, desc: 'Not Found'

  # # params
  param :per_page, String, desc: 'Number record for one page, Default is 10'
  param :page, String, desc: 'Page in total_pages, Default is 1'
  # example
  example 'http://localhost:3019/api/v1/my_links?page=2'
  example 'http://localhost:3019/api/v1/my_links'
  example 'http://localhost:3019/api/v1/my_links?page=3&per_page=5'
  def index
    results = current_user.my_links.desc(:updated_at).paginate(page: params[:page], per_page: params[:per_page] || 10)
    data_render = MyLink.a_t_h(results, %i[short_url_api created_at_mobile])
    message = "Listed your links"
    render_success(message, data_render)
  end

  api :POST, 'api/v1/my_links', 'Create new shorten url'
  description <<-EOF
      =NOTES:
       THIS REQUIRED AUTHENTICATION VIA JWT TOKEN, MAKE SURE YOU ARE SIGN IN AND ADD JIT TOKEN TO HEADER.
      =EX:
        request["Authorization"] = "Bearer 90a7e4bb-85fc-42c4-959a-3478e7253b34"
  EOF
  # errors code if have any
  error code: 404, desc: 'Not Found'

  # # params
  param :my_link, Hash, desc: 'my_link params, this is wrapper' do
    param :a_url, String, desc: 'Long url to shorten', required: true
    param :alias_value, String, desc: '(Optinal) Alias', required: false
  end
  example '{
    "data": [
        {
            "mylink": {
                "short_url": "http://localhost:3000/ru7q",
                "id": "BAh7CEkiCGdpZAY6BkVUSSJCZ2lkOi8vc2hvcnRlbi1saW5rL015TGluay82MTc5MmQ1ZmRkYTViZGIyNmZkODU5OTc_ZXhwaXJlc19pbgY7AFRJIgxwdXJwb3NlBjsAVEkiFnNob3J0X3VybF9zaGFyaW5nBjsAVEkiD2V4cGlyZXNfYXQGOwBUMA==--7d4abed45ab4cd7fcfa6683868c14f2b9da60990",
                "num_of_views": 0,
                "alias_value": "",
                "a_url": "https://en.wikipedia.org/wiki/Bijective_numeration",
                "created_at": 1635331423
            }
        }
    ],
    "result": {
        "code": 200,
        "message": "Shorten Your link successfully!"
    }
  }'
  def create
    link = MyLink.new(params_my_link)
    if params_my_link[:alias_value].present?
      link.short_url = params_my_link[:alias_value]
    end
    link.user = current_user
    if link.save
      return render_success("Shorten Your link successfully!", link.info)
    else
      return render_error_object({ code: 10201, message: link.errors.full_messages.join(', ') })
    end
  end

  def show
    return render_success("Your link details!", @link.info) if @link
    render_error_custom(401, "Not found")
  end

  def update
    return render_error_custom(412, "Link not belongs to user") if @link && @link.user != current_user
    if @link.update(params_my_link)
      return render_success("Your link updated!", @link.info)
    else
      return render_error_object({ code: 10202, message: @link.errors.full_messages.join(', ') })
    end
  end

  def destroy
    return render_error_custom(412, "Link not belongs to user") if @link && @link.user != current_user
    if @link.destroy
      return render_success("Your link destroyed!", {})
    else
      return render_error_object({ code: 10203, message: @link.errors.full_messages.join(', ') })
    end
  end
  private
  def params_my_link
    params.require(:my_link).permit(:a_url, :alias_value)
  end
  def set_link
    @link ||= GlobalID::Locator.locate_signed(params[:id], for: MyLink::SHARING_CONSTANT)
  end
end