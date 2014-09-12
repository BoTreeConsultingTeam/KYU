
      badge = Badge.where( :name => 'new-registered' ).first
      badge.destroy
puts '> Badge successfully removed'