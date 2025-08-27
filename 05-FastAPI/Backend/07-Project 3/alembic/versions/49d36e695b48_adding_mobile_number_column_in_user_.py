"""adding  mobile number column in User table

Revision ID: 49d36e695b48
Revises: 
Create Date: 2025-08-27 10:26:07.175612

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '49d36e695b48'
down_revision: Union[str, Sequence[str], None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.add_column('users', sa.Column('mobile_number', sa.String(length=15), nullable=True))
    


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_column('users', 'mobile_number')
    pass
