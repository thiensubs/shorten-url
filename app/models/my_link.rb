class MyLink
  URL_REGEXP = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  include Mongoid::Document
  include Mongoid::Timestamps
  include ArrayToHash
  SHARING_CONSTANT = 'short_url_sharing'.freeze
  ALPHABET =
  "gm4s96eyl2w5uahzfcvpkndrt78xqb3fcvpkndrt78xqb3".split(//)
  # remove 0 and O,o easy to mistake
  # remove 1 and i, keep j

  ## Assocications
  belongs_to :user
  
  delegate :email, to: :user, prefix: :by, allow_nil: true
  field :a_url,              type: String, default: "" 
  field :alias_value,                    type: String, default: ""
  field :short_url,                type: String, default: "" 
  field :global_id,                type: String, default: ""
  field :meta_data,                type: Hash
  field :num_of_views,             type: Integer, default: 0
  ## Validations
  validates :a_url, presence: true
  validates :alias_value, uniqueness: true, :if => Proc.new{|f| f.alias_value.present? } 
  validates :a_url, format: { with: URL_REGEXP, message: 'You provided invalid URL' }
  validates :a_url, length: { minimum: 15 }

  ## Callbacks
  before_create :set_short_url

  ## Methods
  def make_cumsum_ord_list(link)
    link.split(//).map{|e| e.ord}.inject([0]){ |(p,*ps),v| [v+p,p,*ps] }.reverse[1..-1]
  end
  
  def bijective_encode(i)
    return ALPHABET[0] if i == 0
    s = ''
    base = ALPHABET.length
    while i > 0
      s << ALPHABET[i.modulo(base)]
      i /= base
    end
    s.reverse
  end

  def make_short_url
    bijective_encode(make_cumsum_ord_list(self.to_sgid(expires_in: nil, for: SHARING_CONSTANT).to_s).sum())
  end

  def set_short_url
    if alias_value.blank?
      self.short_url = make_short_url
    else
      self.short_url = alias_value
    end
  end

  def plus_viewed
    self.update(num_of_views: self.num_of_views+1)
  end

  before_create do |document|
    self.global_id = document.to_sgid(expires_in: nil, for: SHARING_CONSTANT).to_s
  end

  def short_url_api
    Rails.application.routes.url_helpers.point_now_url(short_url, host: ActionMailer::Base.default_url_options.values.join(':'))
  end

  def created_at_mobile
    created_at.to_i
  end
  
  def info
    i = self
    [
      mylink: {
        short_url: i.short_url_api,
        id: i.global_id,
        num_of_views: i.num_of_views,
        alias_value: i.alias_value,
        a_url: i.a_url,
        created_at: i.created_at_mobile,
      }
    ]
  end
end
