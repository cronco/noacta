module NoACTA

  ##
  # NoACTA Members of European Parliament
  module MEPS

    ##
    # Wrapper, if API fails, return existing
    def self.get()
      from_api() || preset()
    end

    ##
    # Load parliament members from API
    # TODO: Load from itsyourparliament.eu API
    def self.from_api()
      nil
    end

    ##
    # A list of emails for backup
    def self.preset()
=begin
      [
        'elena.basescu@europarl.europa.eu',
        'theodordumitru.stolojan@europarl.europa.eu',
        'monica.macovei@europarl.europa.eu',
        'traian.ungureanu@europarl.europa.eu',
        'cristiandan.preda@europarl.europa.eu',
        'marian-jean.marinescu@europarl.europa.eu',
        'iosif.matula@europarl.europa.eu',
        'sebastianvalentin.bodu@europarl.europa.eu',
        'petru.luhan@europarl.europa.eu',
        'rares-lucian.niculescu@europarl.europa.eu',
        'oana.antonescu@europarl.europa.eu',
        'adrian.severin@europarl.europa.eu',
        'rovana.plumb@europarl.europa.eu',
        'ioanmircea.pascu@europarl.europa.eu',
        'silviaadriana.ticau@europarl.europa.eu',
        'dacianaoctavia.sarbu@europarl.europa.eu',
        'corina.cretu@europarl.europa.eu',
        'victor.bostinaru@europarl.europa.eu',
        'georgesabin.cutas@europarl.europa.eu',
        'catalin-sorin.ivan@europarl.europa.eu',
        'ioan.enciu@europarl.europa.eu',
        'norica.nicolai@europarl.europa.eu',
        'adinaioana.valean@europarl.europa.eu',
        'adinaioana.valean@europarl.europa.eu',
        'renate.weber@europarl.europa.eu',
        'ramonanicole.manescu@europarl.europa.eu',
        'cristiansilviu.busoi@europarl.europa.eu',
        'tudorcorneliu.vadim@europarl.europa.eu',
        'george.becali@europarl.europa.eu',
        'laszlo.tokes@europarl.europa.eu',
        'iuliu.winkler@europarl.europa.eu',
        'csaba.sogor@europarl.europa.eu',
        'vasilicaviorica.dancila@europarl.europa.eu'
      ]
=end
      ['stas+acta@nerd.ro', 'alin+acta@fsck.ro']
    end

  end #module
end #module
