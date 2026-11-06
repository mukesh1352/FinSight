from collections.abc import Iterable


def calculate_total_expense(transactions: Iterable[float]) -> float:
    """Calculate the total value of financial transactions."""
    return round(sum(transactions), 2)


def calculate_average_expense(transactions: list[float]) -> float:
    """Calculate the average transaction value."""
    if not transactions:
        return 0.0

    return round(sum(transactions) / len(transactions), 2)


def get_transaction_summary(
    transactions: list[float],
) -> dict[str, float | int]:
    """Return a basic financial transaction summary."""
    return {
        "total": calculate_total_expense(transactions),
        "average": calculate_average_expense(transactions),
        "count": len(transactions),
    }


if __name__ == "__main__":
    sample_transactions = [125.50, 89.99, 250.00, 45.75]

    summary = get_transaction_summary(sample_transactions)

    print("FinSight Transaction Summary")
    print(f"Total: ₹{summary['total']}")
    print(f"Average: ₹{summary['average']}")
    print(f"Transactions: {summary['count']}")
