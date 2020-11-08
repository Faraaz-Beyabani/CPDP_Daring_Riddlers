import csv
import json
from collections import defaultdict, Counter

import numpy as np

def prepare_complaint_json():
    data = csv.reader(open('data/severe_allegations_per_district_per_year.csv'))
    headers = next(data)

    complaint_dict = defaultdict(dict)

    for name, year, count in data:
        complaint_dict[name][year] = int(count)

    with open('data/complaints.json', mode='w+') as fp:
        json.dump(complaint_dict, fp)

    return complaint_dict

def prepare_officer_json():
    data = csv.reader(open('data/officers_per_district.csv'))
    headers = next(data)

    officer_dict = defaultdict(dict)

    for name, year, count in data:
        officer_dict[name][year] = int(count)

    with open('data/officers.json', mode='w+') as fp:
        json.dump(officer_dict, fp)

    return officer_dict

def prepare_population_json():
    data = csv.reader(open('data/population_per_district.csv'))
    headers = next(data)

    population_dict = {}

    for name, count in data:
        population_dict[name] = int(count)

    with open('data/population.json', mode='w+') as fp:
        json.dump(population_dict, fp)

    return population_dict

def district_buckets():
    north = ['16th','17th','24th','20th','19th']
    central = ['14th', '18th', '12th', '1st', '9th', '2nd']
    west = ['25th', '15th', '11th', '10th', '8th']
    south = ['7th', '3rd', '6th', '4th', '22nd', '5th']

    return north, central, west, south

def merge_dicts(key_list, dict_dict):
    result = Counter(dict_dict[key_list[0]])
    for key in key_list[1:]:
        result += Counter(dict_dict[key])
        
    return result

def merge_values(key_list, int_dict):
    result = 0
    for key in key_list:
        result += int_dict[key]
    
    return result

def format_data(complaints, police, population):
    y = np.asarray(list(complaints.values()))
    y = y / population

    years = list(complaints.keys())
    years = [int(x) for x in years]

    years = np.asarray(years) 
    years = np.reshape(years, (*years.shape, 1))

    cops = np.asarray(list(police.values()))
    cops = np.reshape(cops, (*cops.shape, 1))

    X = np.append(years, cops, axis=1)
    
    return X, y