# frozen_string_literal: true

require 'socket'
require 'json'
require_relative 'db/client'

server = TCPServer.new('localhost', 8000)

def handle_request(socket)
  request = socket.gets
  db = DB.new

  method, path, version = request.split(' ', 3)

  if path == '/users' && method == 'GET'
    users = db.execute('SELECT * FROM users')    

    response = users.map { |user| { id: user[0], name: user[1]} }.to_json

    socket.print "HTTP/1.1 200 OK\r\n" +
                 "Content-Type: application/json\r\n" +
                 "Content-Length: #{response.bytesize}\r\n" +
                 "Connection: close\r\n"

    socket.print "\r\n"

    socket.print response
  elsif path.match(/\/users\/\d/) && method == 'GET'
    id = path.split('/').last.to_i
    user = db.execute('SELECT * FROM users WHERE id = ?', id).first

    if user
      response = { id: user[0], name: user[1] }.to_json

      socket.print "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: application/json\r\n" +
                    "Content-Length: #{response.bytesize}\r\n" +
                    "Connection: close\r\n"

      socket.print "\r\n"      

      socket.print response
    else
      message = { error: "Not Found" }.to_json

      socket.print "HTTP/1.1 404 Not Found\r\n" +
                  "Content-Type: application/json\r\n" +
                  "Content-Length: #{message.size}\r\n" +
                  "Connection: close\r\n"

      socket.print "\r\n"

      socket.print message
    end
  else
    message = { error: "Not Found" }.to_json

    socket.print "HTTP/1.1 404 Not Found\r\n" +
                 "Content-Type: application/json\r\n" +
                 "Content-Length: #{message.size}\r\n" +
                 "Connection: close\r\n"

    socket.print "\r\n"

    socket.print message
  end

  socket.close
  db.close
end

loop do
  socket = server.accept

  Thread.new do
    handle_request(socket)
  end
end
