package com.atom.billing.utils;

import java.time.format.DateTimeParseException;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Period {

    /**
     * The number of years.
     */
    private final int years;
    /**
     * The number of months.
     */
    private final int months;
    /**
     * The number of days.
     */
    private final int days;

    /**
     * A constant for a period of zero.
     */
    public static final Period ZERO = new Period(0, 0, 0);

    private static final Pattern PATTERN =
            Pattern.compile("([-+]?)P(?:([-+]?[0-9]+)Y)?(?:([-+]?[0-9]+)M)?(?:([-+]?[0-9]+)W)?(?:([-+]?[0-9]+)D)?", Pattern.CASE_INSENSITIVE);

    /**
     * Constructor.
     *
     * @param years  the amount
     * @param months  the amount
     * @param days  the amount
     */
    private Period(int years, int months, int days) {
        this.years = years;
        this.months = months;
        this.days = days;
    }

    //-----------------------------------------------------------------------
    /**
     * Gets the amount of years of this period.
     * <p>
     * This returns the years unit.
     * <p>
     * The months unit is not automatically normalized with the years unit.
     * This means that a period of "15 months" is different to a period
     * of "1 year and 3 months".
     *
     * @return the amount of years of this period, may be negative
     */
    public int getYears() {
        return years;
    }

    /**
     * Gets the amount of months of this period.
     * <p>
     * This returns the months unit.
     * <p>
     * The months unit is not automatically normalized with the years unit.
     * This means that a period of "15 months" is different to a period
     * of "1 year and 3 months".
     *
     * @return the amount of months of this period, may be negative
     */
    public int getMonths() {
        return months;
    }

    /**
     * Gets the amount of days of this period.
     * <p>
     * This returns the days unit.
     *
     * @return the amount of days of this period, may be negative
     */
    public int getDays() {
        return days;
    }


    /**
     * Creates an instance.
     *
     * @param years  the amount
     * @param months  the amount
     * @param days  the amount
     */
    private static Period create(int years, int months, int days) {
        if ((years | months | days) == 0) {
            return ZERO;
        }
        return new Period(years, months, days);
    }

    //-----------------------------------------------------------------------
    /**
     * Obtains a {@code Period} from a text string such as {@code PnYnMnD}.
     * <p>
     * This will parse the string produced by {@code toString()} which is
     * based on the ISO-8601 period formats {@code PnYnMnD} and {@code PnW}.
     * <p>
     * The string starts with an optional sign, denoted by the ASCII negative
     * or positive symbol. If negative, the whole period is negated.
     * The ASCII letter "P" is next in upper or lower case.
     * There are then four sections, each consisting of a number and a suffix.
     * At least one of the four sections must be present.
     * The sections have suffixes in ASCII of "Y", "M", "W" and "D" for
     * years, months, weeks and days, accepted in upper or lower case.
     * The suffixes must occur in order.
     * The number part of each section must consist of ASCII digits.
     * The number may be prefixed by the ASCII negative or positive symbol.
     * The number must parse to an {@code int}.
     * <p>
     * The leading plus/minus sign, and negative values for other units are
     * not part of the ISO-8601 standard. In addition, ISO-8601 does not
     * permit mixing between the {@code PnYnMnD} and {@code PnW} formats.
     * Any week-based input is multiplied by 7 and treated as a number of days.
     * <p>
     * For example, the following are valid inputs:
     * <pre>
     *   "P2Y"             -- Period.ofYears(2)
     *   "P3M"             -- Period.ofMonths(3)
     *   "P4W"             -- Period.ofWeeks(4)
     *   "P5D"             -- Period.ofDays(5)
     *   "P1Y2M3D"         -- Period.of(1, 2, 3)
     *   "P1Y2M3W4D"       -- Period.of(1, 2, 25)
     *   "P-1Y2M"          -- Period.of(-1, 2, 0)
     *   "-P1Y2M"          -- Period.of(-1, -2, 0)
     * </pre>
     *
     * @param text  the text to parse, not null
     * @return the parsed period, not null
     * @throws DateTimeParseException if the text cannot be parsed to a period
     */
    public static Period parse(CharSequence text) {
        Objects.requireNonNull(text, "text");
        Matcher matcher = PATTERN.matcher(text);
        if (matcher.matches()) {
            int negate = ("-".equals(matcher.group(1)) ? -1 : 1);
            String yearMatch = matcher.group(2);
            String monthMatch = matcher.group(3);
            String weekMatch = matcher.group(4);
            String dayMatch = matcher.group(5);
            if (yearMatch != null || monthMatch != null || dayMatch != null || weekMatch != null) {
                try {
                    int years = parseNumber(text, yearMatch, negate);
                    int months = parseNumber(text, monthMatch, negate);
                    int weeks = parseNumber(text, weekMatch, negate);
                    int days = parseNumber(text, dayMatch, negate);
                    days = Math.addExact(days, Math.multiplyExact(weeks, 7));
                    return create(years, months, days);
                } catch (NumberFormatException ex) {
                    throw new DateTimeParseException("Text cannot be parsed to a Period", text, 0, ex);
                }
            }
        }
        throw new DateTimeParseException("Text cannot be parsed to a Period", text, 0);
    }


    private static int parseNumber(CharSequence text, String str, int negate) {
        if (str == null) {
            return 0;
        }
        int val = Integer.parseInt(str);
        try {
            return Math.multiplyExact(val, negate);
        } catch (ArithmeticException ex) {
            throw new DateTimeParseException("Text cannot be parsed to a Period", text, 0, ex);
        }
    }
}
