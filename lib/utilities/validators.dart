final gameName = (String value) => value.isEmpty
    ? 'Please enter at least 1 character'
    : value.length > 8
        ? 'Game names must be less then 8 characters.'
        : null;

final gamePassword = (String value) => value.isEmpty
    ? 'Please enter at least 1 character'
    : value.length > 8
        ? 'Passwords must be less then 8 characters.'
        : null;
