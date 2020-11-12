import csv
import json
from collections import defaultdict, Counter

import numpy as np

def make_ordinal(n):
    '''
    Convert an integer into its ordinal representation::

        make_ordinal(0)   => '0th'
        make_ordinal(3)   => '3rd'
        make_ordinal(122) => '122nd'
        make_ordinal(213) => '213th'
    '''
    n = int(n)
    suffix = ['th', 'st', 'nd', 'rd', 'th'][min(n % 10, 4)]
    if 11 <= (n % 100) <= 13:
        suffix = 'th'
    return str(n) + suffix

def prepare_complaints():
    data = csv.reader(open('data/severe_allegations_per_district_per_year.csv'))
    headers = next(data)

    complaint_dict = defaultdict(dict)

    for name, year, count in data:
        complaint_dict[name][year] = int(count)

    return complaint_dict

def prepare_officers():
    data = csv.reader(open('data/officers_per_district.csv'))
    headers = next(data)

    officer_dict = defaultdict(dict)

    for name, year, count in data:
        officer_dict[name][year] = int(count)

    return officer_dict

def prepare_population():
    data = csv.reader(open('data/population_per_district.csv'))
    headers = next(data)

    population_dict = {}

    for name, count in data:
        population_dict[name] = int(count)

    return population_dict

def prepare_ratios():
    data = csv.reader(open('data/allegation_proportions_per_unit.csv'))
    headers = next(data)
    
    uof_index = 10
    ills_index = 15
    
    uof_ratios = defaultdict(dict)
    ill_search_ratios = defaultdict(dict)
    
    for stat in data:
        name = make_ordinal(int(stat[0]))
        year = stat[1]
        
        uof_ratios[name][year] = float(stat[uof_index])
        ill_search_ratios[name][year] = float(stat[ills_index])
    
    return uof_ratios, ill_search_ratios

def merge_dicts(key_list, dict_dict):
    result = Counter(dict_dict[key_list[0]])
    for key in key_list[1:]:
        result += Counter(dict_dict[key])
        
    return result

def avg_dicts(key_list, dict_dict):
    total_num = len(key_list)
    result = merge_dicts(key_list, dict_dict)
        
    keys = list(result.keys())
    vals = list(result.values())
    
    avg_result = {keys[i]:round(vals[i]/total_num, 4) for i in range(len(keys))}
        
    return avg_result

def merge_values(key_list, int_dict):
    result = 0
    for key in key_list:
        result += int_dict[key]
    
    return result

def format_data(complaints, population, *args):
    '''
    Builds a feature vector suitable for linear regression.
    
    complaints: A dictionary where the key is the year and the value is the number of complaints
    population: An integer corresponding to the population of a region
    *args     : Features in the form of dictionaries, key being year and value being the numeric feature
    '''
    y = np.asarray(list(complaints.values()))
    y = y / population

    years = list(complaints.keys())
    years = [int(x) for x in years]

    years = np.asarray(years) 
    X = np.reshape(years, (*years.shape, 1))
    
    for feature in args:
        format_feat = np.asarray(list(feature.values()))
        format_feat = np.reshape(format_feat, (*format_feat.shape, 1))

        X = np.append(X, format_feat, axis=1)
    
    return X, y