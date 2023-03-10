module PaperTrail
  module Background
    module RSpecHelpers
      module InstanceMethods
        # enable versioning for specific blocks (at instance-level)
        def with_versioning(&block)
          was_enabled = ::PaperTrail.enabled?
          ::PaperTrail.enabled = true

          normally_open_transactions = ActiveRecord::Base.normally_open_transactions
          ActiveRecord::Base.normally_open_transactions = 2

          # ensure that VersionJobs are executed
          perform_enqueued_jobs only: VersionJob, &block
        ensure
          ::PaperTrail.enabled = was_enabled
          ActiveRecord::Base.normally_open_transactions = normally_open_transactions
        end
      end

      module ClassMethods
        # enable versioning for specific blocks (at class-level)
        def with_versioning(&block)
          context "with versioning", versioning: true do
            around do |example|
              normally_open_transactions = ActiveRecord::Base.normally_open_transactions
              ActiveRecord::Base.normally_open_transactions = 2

              perform_enqueued_jobs only: VersionJob do
                example.run
              end

              ActiveRecord::Base.normally_open_transactions = normally_open_transactions
            end

            class_exec(&block)
          end
        end
      end

    end
  end
end