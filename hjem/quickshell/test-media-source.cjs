// Run: node hjem/quickshell/test-media-source.cjs
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const qml = readFileSync(`${__dirname}/MediaPlayerCard.qml`, 'utf8');
const expression = qml.match(/readonly property var activePlayer: (.+)/)[1];
const select = new Function('players', 'selectedPlayer', `return ${expression}`);
const first = {}, second = {};
assert.equal(select([], null), null);
assert.equal(select([first, second], null), first);
assert.equal(select([first, second], second), second);
assert.equal(select([second, first], second), second);
assert.equal(select([first], second), first);
assert.equal(select([], second), null);
console.log('Media source selection checks passed');
