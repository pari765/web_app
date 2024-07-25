import re

def is_valid_credit_card(card_number):
    # Regex to match valid credit card format
    pattern = re.compile(r'^(4|5|6)\d{3}(-?\d{4}){3}$')
    
    if not pattern.match(card_number):
        return "Invalid"
    
    # Remove hyphens for checking consecutive repeated digits
    card_number = card_number.replace('-', '')
    
    # Check for consecutive repeated digits
    for i in range(len(card_number) - 3):
        if card_number[i] == card_number[i+1] == card_number[i+2] == card_number[i+3]:
            return "Invalid"
    
    return "Valid"

# Read input
n = int(input())
for _ in range(n):
    card_number = input().strip()
    print(is_valid_credit_card(card_number))
