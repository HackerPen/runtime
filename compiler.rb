# frozen_string_literal: false

require 'open3'
require 'openssl'
require 'fileutils'
require 'timeout'

# doc: https://gist.github.com/wteuber/5318013
class String
  def encrypt
    cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
    cipher.key = cipher.random_key
    s = cipher.update(self) + cipher.final

    s.unpack1('H*').upcase
  end
end

# doc: false
# rubocop:disable Metrics/MethodLength
class Compiler
  LANG_TO_EXTENSION = {
    'java' => 'java',
    'javascript' => 'js',
    'kotlin' => 'kt',
    'python3' => 'py',
    'python' => 'py',
    'ruby' => 'rb',
    'golang' => 'go',
    'cpp' => 'cpp',
    'c' => 'c'
  }.freeze

  TIMEOUT_SECONDS = 10
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Layout/LineLength
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def self.run(access_code, lang, code)
    extension = LANG_TO_EXTENSION[lang]
    directory = access_code.encrypt

    FileUtils.mkdir_p("/hackerpen/#{directory}")
    filename = "/hackerpen/#{directory}/solution.#{extension}"
    stdout, stderr, _status = nil

    begin
      Timeout.timeout(TIMEOUT_SECONDS) do
        File.write(filename, code)

        if %w[ruby python python3 java].include?(lang)
          stdout, stderr, _status = Open3.capture3("#{lang} #{filename}")
        elsif lang == 'golang'
          stdout, stderr, _status = Open3.capture3("go run #{filename}")
        elsif lang == 'javascript'
          stdout, stderr, _status = Open3.capture3("node #{filename}")
        elsif lang == 'kotlin'
          jar_path = "/hackerpen/#{directory}/solution.jar"
          stdout, stderr, _status = Open3.capture3("kotlinc #{filename} -d #{jar_path}; java -jar #{jar_path}")
        elsif lang == 'cpp'
          stdout, stderr, _status = Open3.capture3("g++ #{filename} -o /hackerpen/#{directory}/solution; cd /hackerpen/#{directory}; ./solution")
        elsif lang == 'c'
          stdout, stderr, _status = Open3.capture3("gcc #{filename} -o /hackerpen/#{directory}/solution; cd /hackerpen/#{directory}; ./solution")
        end

        output = stderr != '' ? stderr : stdout
        output.gsub!(filename, "solution.#{extension}")
        output.gsub!("#{directory}/solution.#{extension}", "solution.#{extension}")

        output
      end
    rescue Timeout::Error
      "solution.#{extension}: execution timeout (> 10 seconds)"
    end
  ensure
    File.delete(filename)
    FileUtils.rm_rf("/hackerpen/#{directory}")
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Layout/LineLength
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
end
# rubocop:enable Metrics/MethodLength
