# frozen_string_literal: true

module DatabaseWorker
  class PgheroWorker < ApplicationWorker
    def perform
      clean_old_records
      track_new
    end

    def clean_old_records
      PgHero::SpaceStats.where("captured_at < ?", 1.month.ago).delete_all
      PgHero::QueryStats.where("captured_at < ?", 1.month.ago).delete_all
    end

    def track_new
      PgHero.capture_query_stats if PgHero.query_stats_enabled?
      PgHero.capture_space_stats
    end
  end
end
