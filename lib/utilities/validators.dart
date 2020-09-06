final oneToFifteenChars = (String value) => value.isEmpty
    ? 'Please enter at least 1 character'
    : value.length > 15 ? 'Game names can be up to 15 characters.' : null;
