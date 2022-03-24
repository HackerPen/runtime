# frozen_string_literal: false

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe Compiler do
  it 'compiles ruby' do
    code = <<-CODE
      puts "hello world this is ruby"
    CODE

    output = described_class.run('access_code', 'ruby', code)
    expect(output).to eq("hello world this is ruby\n")
  end

  it 'compiles python' do
    code = <<~CODE
      print("hello world this is python")
    CODE

    output = described_class.run('access_code', 'python', code)
    expect(output).to eq("hello world this is python\n")
  end

  it 'compiles python3' do
    code = <<~CODE
      print("hello world this is python3")
    CODE

    output = described_class.run('access_code', 'python3', code)
    expect(output).to eq("hello world this is python3\n")
  end

  it 'compiles golang' do
    code = <<~CODE
      package main
      import "fmt"
      func main() {
          fmt.Println("hello world this is golang")
      }
    CODE

    output = described_class.run('access_code', 'golang', code)
    expect(output).to eq("hello world this is golang\n")
  end

  it 'compiles java' do
    code = <<~CODE
      class Main {
        public static void main(String[] args) {
          System.out.println("hello world this is java");
        }
      }
    CODE

    output = described_class.run('access_code', 'java', code)
    expect(output).to eq("hello world this is java\n")
  end

  it 'compiles c' do
    code = <<~CODE
      // Your first C program
      #include <stdio.h>

      int main() {
        printf("hello world this is c");

        return 0;
      }
    CODE
    output = described_class.run('access_code', 'c', code)
    expect(output).to eq("hello world this is c")
  end

  it 'compiles c++' do
    code = <<~CODE
      // Your First C++ program
      #include <iostream>

      int main() {
        std::cout << "hello world this is cpp";
        return 0;
      }
    CODE
    output = described_class.run('access_code', 'cpp', code)
    expect(output).to eq("hello world this is cpp")
  end

  it 'compiles javascript' do
    code = <<~CODE
      function myFunction(p1, p2) {
        return p1 * p2;
      }
      console.log(myFunction(1,2))
    CODE

    output = described_class.run('access_code', 'javascript', code)
    expect(output).to eq("2\n")
  end

  it 'outputs timeout' do
    code = <<-CODE
      while true do
        puts "hello world this is ruby"
      end
    CODE

    output = described_class.run('access_code', 'ruby', code)
    expect(output).to eq('solution.rb: execution timeout (> 10 seconds)')
  end
end
# rubocop:enable Metrics/BlockLength
