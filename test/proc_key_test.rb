require 'test/test_helper'

class ProcKeyTest < Test::Unit::TestCase
  context 'With a Proc returning a string for a key pair' do
    setup do
      @password = 'boost facile'
      rebuild_model key_pair: proc {
        File.read(File.join(FIXTURES_DIR, 'keypair.pem'))
      }
      @dummy = Dummy.new
      @dummy.secret = 'Shhhh'
    end

    should_encypted_and_decrypt
  end

  context 'With a Proc returning a key object' do
    setup do
      @password = 'boost facile'
      @private_key = OpenSSL::PKey::RSA.new(2048)
      rebuild_model key_pair: proc { @private_key }
      @dummy = Dummy.new
      @dummy.secret = 'Shhhh'
    end

    should_encypted_and_decrypt
  end

  context 'With Procs returning public and private key strings' do
    setup do
      @password = 'boost facile'
      @key_pair = File.read(File.join(FIXTURES_DIR, 'keypair.pem'))

      rebuild_model public_key: proc { @key_pair },
                    private_key: proc { @key_pair }
      @dummy = Dummy.new
      @dummy.secret = 'Shhhh'
    end

    should_encypted_and_decrypt
  end

  context 'With Procs returning public and private key objects' do
    setup do
      @password = 'boost facile'
      @private_key = OpenSSL::PKey::RSA.new(2048)
      @public_key = @private_key.public_key

      rebuild_model public_key: proc { @public_key },
                    private_key: proc { @private_key }
      @dummy = Dummy.new
      @dummy.secret = 'Shhhh'
    end

    should_encypted_and_decrypt
  end
end
