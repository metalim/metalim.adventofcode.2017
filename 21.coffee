{_log,test,expect,testAndRun} = require './util'
ansi = require('ansicolor').nice

rotate = (l)->
	a=l.split '/'
	b=(for y in [0...a.length]
		(for x in [0...a.length]
			a[x][a.length-1-y]
		).join ''
	).join '/'

flip = (l)->
	a=l.split '/'
	b=(for y in [0...a.length]
		(for x in [0...a.length]
			a[y][a.length-1-x]
		).join ''
	).join '/'

show = (s)->
	if not s?.length
		_log.red 'undefined'
		return
	if typeof s is 'string'
		s=s.split '/'
	_log.darkGray '------'
	_log l.join?('') ? l for l in s
	return

show_match = (a,b,c)->
	a = a.split '/' if typeof a is 'string'
	b = b.split '/' if typeof b is 'string'
	c = c.split '/' if typeof c is 'string'
	_log.darkGray '------'
	for lc,y in c
		la = a[y] ? '    '[...a.length]
		lb = b[y] ? '    '[...a.length]
		_log.green la, '  ', lb, '  ', lc
	return


PRECALC = yes

class Solver
	constructor: ( @input )->
		@r = {}
		for l in @input.split '\n'
			[k,v] = l.split ' => '
			if PRECALC
				dupe = @r[k]
			else
				dupe = @r[@find_key k]
			if dupe?
				_log.red 'key dupe', k
			v = v.split '/'
			@r[k] = v
			if PRECALC
				@r[flip k] = v
				k = rotate k
				@r[k] = @r[flip k] = v
				k = rotate k
				@r[k] = @r[flip k] = v
				k = rotate k
				@r[k] = @r[flip k] = v
		return

	find_key: (k)->
		a=k
		for [0..1]
			for [0..3]
				if @r[k]?
					return k
				k = rotate k
			k = flip k
		return

	step: (st,d)->
		len = st.length
		out = ([] for [0...len/d*(d+1)])

		# show st

		# for each subrect
		for i in [0...len] by d
			for j in [0...len] by d

				# key as string
				k = (for y in [i...i+d]
					(for x in [j...j+d]
						st[y][x]
					).join ''
				).join '/'

				if not PRECALC
					k = @find_key k
				unless @r[k]?
					throw new Error "key not found: #{k}"
				#show_match k0, k, @r[k]

				# fill new state
				oy = i/d*(d+1)
				ox = j/d*(d+1)
				for r,y in @r[k]
					for c,x in r
						out[oy+y][ox+x]=c

		out

	solve1: (steps)->
		st = '.#./..#/###'.split '/'

		for step in [1..steps]
			len = st?.length
			_log.clear.darkGray 'step', step, 'len', len
			switch
				when len%2 is 0
					st = @step st,2

				when len%3 is 0
					st = @step st,3

				else
					_log.red 'invalid state', st
					return

		_log.clear ''

		lit = 0
		for r in st
			for c in r when c is '#'
				++lit
		lit

verify = ( expect, inp, args... )->
	s = new Solver inp
	for k, ev of expect
		if ev is v=s["solve#{k}"] args...
			_log.cyan v
		else
			_log.red 'expected', ev, 'actual', v
	return

test.solve1 = ->
	expect '.##/#.#/..#', rotate '.#./..#/###'

	s = new Solver '''
	../.# => ##./#../...
	.#./..#/### => #..#/..../..../#..#
	'''
	expect 12, s.solve1 2
	return

testAndRun ->
	s = new Solver require './input/21.txt'
	#_log s.r
	_log.yellow '1:', s.solve1 5
	_log.yellow '2:', s.solve1 18
	return
