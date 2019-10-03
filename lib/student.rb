require 'sqlite3'
require_relative '../lib/student'

DB = {:conn => SQLite3::Database.new("db/students.db")}

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    return student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
      SQL
    results = DB[:conn].execute(sql)
    students = []
    results.each do |row|
      students << Student.new_from_db(row)
    end
    return students
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name=? LIMIT 1
      SQL
    DB[:conn].execute(sql, name).map do |row|
        student = self.new_from_db(row)
      end.first
  end

  def all_students_in_grade_9
    students
    sql = <<-SQL
      SELECT * FROM students WHERE grade=?
      SQL
    DB[:conn].execute(sql, 9).map do |row|
        students << self.new_from_db(row).name
      end
      return students
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
