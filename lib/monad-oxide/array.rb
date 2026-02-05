# Reopen Array to add some handy capabilities idoimatic to Ruby.
class Array

  ##
  # Take an Array of Results and convert them to a single Result whose value is
  # an Array of Ok or Err values. Ok Results will have only Ok values, and Err
  # Results will have only Err values. A single Err in the input Array will
  # convert the entire Result into an Err.
  #
  # @return [MonadOxide::Result<Array<V>, Array<E>>] A Result whose value is an
  # array of all of the Oks or Errs in the Array.
  def into_result()
    tracker = {
      oks: [],
      errs: [],
    }
    self.each do |result|
      result.match({
        MonadOxide::Ok => ->(x) { tracker[:oks].push(x) },
        MonadOxide::Err => ->(e) { tracker[:errs].push(e) },
      })
    end
    tracker[:errs].empty?() ?
      MonadOxide.ok(tracker[:oks]) :
      MonadOxide.err(tracker[:errs])
  end

end
