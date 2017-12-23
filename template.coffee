{_log,test,expect,main} = require './util'
ansi = require('ansicolor').nice

class Solver
	constructor: ( @input )->
	solve1: (v)->
		v+1
	solve2: (v)->
		v+2

test.solve1 = ->
	s = new Solver ''
	expect 2, s.solve1 1
	return

test.solve2 = ->
	s = new Solver ''
	expect 3, s.solve2 1
	return

main ->
	s = new Solver require './input/1.txt'
	_log.yellow '1:', s.solve1 1
	_log.yellow '2:', s.solve2 2
	return
