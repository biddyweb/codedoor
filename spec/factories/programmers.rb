FactoryGirl.define do
  factory :programmer do
    title 'Test Title'
    rate 20
    availability 'full-time'
    onsite_status 'offsite'
    visibility 'codedoor'
    # Before each spec, the skills are prepopulated
    skills {[Skill.find_by_name('Android')]}
    association :user, factory: :user_checked_terms

    trait :qualified do
      qualified true
      state 'activated'
    end
  end
end
