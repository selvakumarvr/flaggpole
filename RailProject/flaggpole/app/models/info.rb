class Info < ActiveRecord::Base
  belongs_to :alert
  has_many :event_codes, :dependent => :destroy
  has_many :parameters, :dependent => :destroy
  has_many :resources, :dependent => :destroy
  has_many :areas, :dependent => :destroy

  validates_presence_of :category, :event, :urgency, :severity, :certainty
  validates_inclusion_of :category, :in => %w(Geo Met Safety Security Rescue Fire Health Env Transport Infra CBRNE Other)
  validates_inclusion_of :response_type, :in => %w(Shelter Evacuate Prepare Execute Avoid Monitor Assess AllClear None), :allow_blank => true
  validates_inclusion_of :urgency, :in => %w(Immediate Expected Future Past Unknown)
  validates_inclusion_of :severity, :in => %w(Extreme Severe Moderate Minor Unknown)
  validates_inclusion_of :certainty, :in => %w(Observed Likely Possible Unlikely Unknown)

  def zips
    self.areas.map(&:zips).flatten.uniq
  end

  def same_codes
    self.areas.map(&:same_codes).flatten.uniq
  end

end
