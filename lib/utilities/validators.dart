final gameName = (String value) => value.isEmpty
    ? 'Please enter game name'
    : value.length > 8
        ? 'Game names must be less then 8 characters.'
        : null;

final gamePassword = (String value) => value.isEmpty
    ? 'Please enter game password'
    : value.length > 15
        ? 'Passwords must be less then 15 characters.'
        : null;
