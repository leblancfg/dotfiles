import itertools
from pprint import pprint
import sys

import requests


def findkeys(node, kv):
    """
    Find all keys in a dictionary that match a given value.
    """
    if isinstance(node, list):
        for i in node:
            for x in findkeys(i, kv):
                yield x
    elif isinstance(node, dict):
        if kv in node:
            yield node[kv]
        for j in node.values():
            for x in findkeys(j, kv):
                yield x


def get_word_definition(word):
    """
    Get the definition of a word from the dictionary API.
    """
    url = 'https://api.dictionaryapi.dev/api/v2/entries/en/{}'.format(word)
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        return None


def get_synonyms(word):
    """
    Get the synonyms of a word from the dictionary API.
    """
    response = get_word_definition(word)
    synonyms = list(itertools.chain(*findkeys(response, 'synonyms')))
    return synonyms or None


def get_antonyms(word):
    """
    Get the antonyms of a word from the dictionary API.
    """
    response = get_word_definition(word)
    antonyms = list(itertools.chain(*findkeys(response, 'antonyms')))
    return antonyms or None


ACTIONS = {
    'syn': get_synonyms,
    'ant': get_antonyms,
    'def': get_word_definition,
}


if __name__ == '__main__':
    action = sys.argv[1]
    word = sys.argv[2]

    definition = ACTIONS[action](word)
    if definition:
        pprint(definition)
    else:
        pprint('Word not found.')
